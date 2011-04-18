From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: GPT on MD raid
Date: Mon, 18 Apr 2011 17:11:56 +0100
Message-ID: <iohnsc$ggc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi - I was thinking of using a GPT partition on top of a MD raid device. It 
occurs to me that because GPT also puts data at the end of the device, it 
might get confused if the raid device is resized by adding more drives, etc.

Has anyone tried this? Should it work? How should the GPT header get moved 
to the end of the raid device? Will parted fix it?

Should I ditch this idea and delve into the complexities of LVM?

Thanks

Jeremy

