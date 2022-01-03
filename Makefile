run_all_in_parallel:
	make -j test_macos_10_chrome_latest test_macos_12_firefox_latest test_windows_10_edge_latest test_windows_10_chrome_latest

test_macos_10_chrome_latest:
	robot  --variable platform:"MacOS Catalina" --variable browserName:Chrome --variable version:latest --variable visual:false --variable network:false --variable console:false Tests/*.robot

test_macos_12_firefox_latest:
	robot --variable platform:"MacOS Monterey" --variable browserName:Firefox --variable version:latest --variable visual:false --variable network:false --variable console:false Tests/*.robot

test_windows_10_edge_latest:
	robot  --variable platform:"Windows 10" --variable browserName:MicrosoftEdge --variable version:latest --variable visual:false --variable network:false --variable console:false Tests/*.robot

test_windows_10_chrome_latest:
	robot --variable platform:"Windows 10" --variable browserName:Chrome --variable version:latest --variable visual:false --variable network:false --variable console:false Tests/*.robot