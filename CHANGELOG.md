## 0.3.0

### :bangbang: Breaking Changes

* `Identicon.render/1` has been changed to `Identicon.render/2` for additional
identicon implementations.
  * Result is now tagged with {:ok, result} | {:error, reason}
  * Second param is now an optional `opts \\ [type: :githublike, size: :size_5x5]` to minimize the breaking change.
  * Use bang version (`Identicon.render!/2`) to reproduce previous functionality.
