From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Sat, 02 May 2009 13:04:06 +1200
Message-ID: <1241226246.4862.24.camel@ezra>
References: <49F68CE0.2010906@zytor.com>
	 <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	 <1240957153.18303.689.camel@ezra>
	 <18935.35747.471257.202356@notabene.brown> <49F78F26.2040909@zytor.com>
	 <1240963225.18303.858.camel@ezra> <49F7997C.2070808@zytor.com>
	 <1240964410.18303.895.camel@ezra> <49F79F26.9060309@zytor.com>
	 <1240965831.18303.944.camel@ezra>
	 <20090429064333.GB9372@boogie.lpds.sztaki.hu>
	 <87hc04leau.fsf@frosties.localdomain>
	 <1241217394.4418.4.camel@poledra.romunt.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1241217394.4418.4.camel@poledra.romunt.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> It would get worse, as in many situations the installer would succeed,
> and the boot would fail. Many raid 5/6 configurations will spread over
> controllers, and not BIOS supports booting over several controllers. 
> 
Then we teach the bootloaders installer to detect whether all the member
disks are on the same controller, and refuse to install (or atleast warn
at that point) if not.  

That being said, I don't know whether grub2 is smart enough yet to probe
all the controllers for disks, not just the ones accessible via int13.
If this is the case then this particular failure mode is reduced to only
being an issue on unsupported controllers.


-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

