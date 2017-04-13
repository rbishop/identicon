Identicon
=========

An Elixir library for generating GitHub-like symmetrical 5x5 identicons.

## Usage

Just pass a string or `char_list` to `Identicon.render!/2`. You
will get back a Base64 encoded string representing your identicon image.

```elixir
image = Identicon.render! "Elixir"
# => a1070f60bb1e600..."
```

You can just keep using this in memory or write to file and decode into an
image:

```elixir
image = Identicon.render! "Elixir"
:ok = File.write("Elixir.txt", image)
```

```bash
$ cat Elixir.txt | base64 -D -o elixir.png
```

In Ubuntu 16.04:
```bash
cat Elixir.txt | base64 -d > elixir.png
```

## Todo

- [ ] Support various size/pixel count/background color identicons
- [x] Make the identicons symmetric like GitHub's (so cool! :sunglasses:)
- [ ] Support other identicon visual implementations.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Identicon uses the same license as the Elixir programming language. See the
[license
file](https://raw.githubusercontent.com/rbishop/identicon/master/LICENSE) for
more information.
