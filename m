From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: RE: RAID rebuild on Create
Date: Mon, 30 Apr 2007 21:27:37 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704302126500.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301958530.29151@yvahk01.tjqt.qr>
 <e9c3a7c20704301119v1c69aaf0xb272fe85697934cd@mail.gmail.com>
 <Pine.LNX.4.61.0704302030510.29151@yvahk01.tjqt.qr>
 <CE7B1A4EF22E704CBFFD9A35BA5C82221DFC2D@ausx3mpc110.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CE7B1A4EF22E704CBFFD9A35BA5C82221DFC2D@ausx3mpc110.aus.amer.dell.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick_Boyd@Dell.com
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Apr 30 2007 13:54, Patrick_Boyd@Dell.com wrote:
>
>But then the array needs to keep track of where data is so that it knows
>what is "good" and what is "bad."

I assume it knows that, because you can reboot while an array is still
syncing and it Does The Right Thing. Furthermore, there is also the
relatively new mdadm -b option.

>Instead it takes the array to a known
>good state to start out with and you don't have to start out with blank
>disks. 

Jan
-- 
