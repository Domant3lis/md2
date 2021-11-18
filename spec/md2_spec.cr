require "../src/md2.cr"
require "spec"

describe MD2 do
  describe MD2 do
      describe "#get_hash" do
        it "should correctly get the MD2 hashes of ASCII strings" do
          MD2.get_hash("hello").should eq "a9046c73e00331af68917d3804f70655"
        end
      end
  end

  describe String do
    describe "#get_md2" do
      it "should correctly get the MD2 hashes of ASCII strings" do
        "hello, world!".get_md2.should eq "65d39bdcda41f0aeb232d7d90e58bb6c"
        "HELLO< world#".get_md2.should eq "196017fe90a15004e2f8843c7434c112"
      end

      it "should correct get MD2 hashes of strings with latin characters with diacritics" do
        "ąčęėįšųūųééáÁä".get_md2.should eq "b5c95a938c9b56a903e5e58662e9ab3b"
        "Haben Sie Übelkeit".get_md2.should eq "a46f22869dab7a292d6dbb02d538199b"
      end

      it "should get correct MD2 hashes of strings with japanase characters" do
        "濁点".get_md2.should eq "72dd85705b4a41d434b565bcc9f9eb30"
        "日本語を通用する大和民族が国民の大半を占める。自然地理的には、ユーラシア大陸の東に位置しており、環太平洋火山帯を構成する".get_md2.should eq "30f32d86d66f7293644d556b216d203e"
      end

      it "should get correct MD2 hashes of strings with Chinese characters" do
        "半濁点".get_md2.should eq "c5f9f5743844685b7c35f6bea54b7166"
      end

      it "should get correct MD2 hashes of strings with number of characters equally divisible by 16 (block size)" do
        "hello once again".get_md2.should eq "2e9166355d444b789271027773d1f4f0"
        "Lorem ipsum dolor sit amet, c...".get_md2.should eq "7b63ca9392fc36e45652e3d49d99f679"
      end

      it "emoji" do
        "Hello 🌐".get_md2.should eq "ab4476b8c2ae5e7fc62fa4bcc9037174"
        "😀 😃 😄 😁 😆 😅 😂 🤣 🥲 ☺️ 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐 🤓 😎 🥸 🤩 🥳 😏 😒 😞 😔 😟 😕 🙁 ☹️ 😣 😖 😫 😩 🥺 😢 😭 😤 😠 😡 🇩🇯 👩‍👩‍👦‍👦".get_md2.should eq "ca23efd40dff964b95b1ddbe757de2ee"
      end
    end
  end
end
