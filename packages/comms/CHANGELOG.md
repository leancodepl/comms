## 1.0.0

- Introduce covariant listening by filtering `Listener`s contravariantly (#58)
    - Before `Listener<SubClass>` would also receive `<SupClass>` messages which
    would throw in `onMessage()` forcing you to only ever listen to `<SupClass>`,
    now you can safely use subtyping of messages.

## 0.0.11

- Fix new dart compatibility issue

## 0.0.10

- Fix one off messages getting buffered when there are active `Listener`s (#54)

## 0.0.9

- Add `oneOff` to `send()` for marking message as available to read only once
from buffer

- Add `onInitialMessage()` to `MultiListener` mixin

## 0.0.8+2

- Add README (#46)

## 0.0.8+1

- Make `MessageSinkRegister` public (#44)

## 0.0.8

- Make logging optional, add `loggingEnabled` and `log` to `MessageSinkRegister` (#42)

## 0.0.7

- Add `onInitialMessage()` to `Listener` mixin (#41)

## 0.0.6

- Add MultiListener and ListenerDelegate

## 0.0.5

- Add documentation, stop depending on flutter

## 0.0.4

- Add ListenerBloc, MessageListener and MultiMessageListener widget

## 0.0.3

- Downgrade flutter_hooks to 0.18.2, add tests

## 0.0.2

- Same as v0.0.1, but release using GitHub Actions

## 0.0.1

- Initial release
