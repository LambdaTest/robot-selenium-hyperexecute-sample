test_macos_12_chrome_latest:
	robot  --variable platform:"MacOS Catalina" --variable browserName:Chrome --variable version:latest --variable visual:false --variable network:false --variable console:false Tests/*.robot

test_macos_12_firefox_latest:
	robot --variable platform:"MacOS Catalina" --variable browserName:Firefox --variable version:latest --variable visual:false --variable network:false --variable console:false Tests/*.robot

test_windows_10_edge_latest:
	robot --variable platform:"Windows 10" --variable browserName:MicrosoftEdge --variable version:latest --variable visual:false --variable network:false --variable console:false Tests/*.robot

test_windows_10_chrome_latest:
	robot --variable platform:"Windows 10" --variable browserName:Chrome --variable version:latest --variable visual:false --variable network:false --variable console:false Tests/*.robot