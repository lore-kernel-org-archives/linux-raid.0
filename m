From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: SW-RAID 1 and kernel 2.4.18
Date: 26 Nov 2002 14:52:38 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <as0tvm$lu$1@cesium.transmeta.com>
References: <984305F1827DD5118FEA0000D1105F0A01BDC029@HW_MAIL> <3DE3CC8D.2080104@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <3DE3CC8D.2080104@mvista.com>
By author:    Steven Dake <sdake@mvista.com>
In newsgroup: linux.dev.raid
> 
> IDE was not designed to hotswap.  The trays are not "hot swappable" in 
> that they can only be swapped while the system is off.
> 

There are IDE cards which can tristate -- effectively disconnect -- their
outputs.  Some of them can even control the power to the drive.  Such
drives are safe to hotswap, if they have been disconnected before
removing them.  This requires driver support, however, and I'm not
sure if Linux has that.

	-hpa
-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
"Unix gives you enough rope to shoot yourself in the foot."
http://www.zytor.com/~hpa/puzzle.txt	<amsp@zytor.com>
