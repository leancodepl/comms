## 1.0.0

- Move bloc related apis to comms package, add README (#61)

## 0.0.6+2

- Fix `StateSender` to only send messages when state is actually emitted

## 0.0.6

- Fix `useMessageListener`s `onInitialMessage` getting called during build (#49)

## 0.0.5

- **Breaking:** Change `useMessageListener`s `onInitialMessage` and `keys` to named parameters (#47)

## 0.0.4+1

- Upgrade comms package

## 0.0.4

- Add `onInitialMessage` to `ListenerBloc`, `ListenerCubit`, `MessageListener` and `useMessageListener` (#43)

## 0.0.3+2

- Fix `MessageListener` type parameter (#40)

## 0.0.3+1

- Fix export of StateSender

## 0.0.3

- Add StateSender mixin

## 0.0.2

- Fix useMessageListener

## 0.0.1+3

- Fix useMessageListener not using type parameter Message

## 0.0.1+2

- Add export of comms package

## 0.0.1+1

- Downgrade flutter_hooks to 0.18.2

## 0.0.1

- Initial release
