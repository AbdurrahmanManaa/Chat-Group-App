import 'package:chatapp/blocs/bloc/auth_event.dart';
import 'package:chatapp/blocs/bloc/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoginLoading());
        try {
          UserCredential user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: event.email, password: event.password);
          emit(LoginSuccess());
        } on FirebaseAuthException catch (ex) {
          if (ex.code == 'user-not-found') {
            emit(LoginFailure(errorMessage: 'User not found!'));
          } else if (ex.code == 'wrong-password') {
            emit(LoginFailure(errorMessage: 'Wrong password!'));
          }
        } catch (e) {
          emit(LoginFailure(errorMessage: 'Something went wrong!'));
        }
      } else if (event is RegisterEvent) {
        emit(RegisterLoading());
        try {
          UserCredential user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: event.email, password: event.password);
          emit(RegisterSuccess());
        } on FirebaseAuthException catch (ex) {
          if (ex.code == 'weak-password') {
            emit(RegisterFailure(errorMessage: 'Weak password!'));
          } else if (ex.code == 'email-already-in-use') {
            emit(RegisterFailure(errorMessage: 'Email already in use!'));
          }
        } catch (e) {
          emit(RegisterFailure(errorMessage: 'Something went wrong!'));
        }
      }
    });
  }
}
