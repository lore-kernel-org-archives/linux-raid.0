From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 17:04:12 -0700
Message-ID: <49F7997C.2070808@zytor.com>
References: <1240574900.4507.2076.camel@ezra>	 <87hc0axhg9.fsf@frosties.localdomain>	<49F68CE0.2010906@zytor.com>	 <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>	 <1240957153.18303.689.camel@ezra>	 <18935.35747.471257.202356@notabene.brown>  <49F78F26.2040909@zytor.com> <1240963225.18303.858.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1240963225.18303.858.camel@ezra>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Reurich wrote:
> 
>> For this to be reliable, there is only one sensible configuration, which
>> is for /boot to be a RAID-1, which is better handled by -- guess what --
>> partitioning systems; and we already have quite a few of those that work
>> just fine, thank you.  Otherwise there WILL be configurations -- caused
>> by controller failures if nothing else -- that simply will not boot even
>> though the system is otherwise functional.  Promoting this kind of stuff
>> is criminally stupid.
> 
> I disagree.  Grub is quite capable of booting from and assembling a
> raid5 volume and accessing it's partitions contents, even if the array
> is degraded.  All I'm asking for is that the first 64 kbytes of the disk
> be reserved and some of it possibly (but not necessarily) replicated so
> that a bootloader capable of assembling a raid array can be installed on
> the start of each member disk so that whatever disk the bios decides to
> boot from, it will always boot.
>  

Grub is capable of doing that IF THE FIRMWARE CAN REACH IT.

You seem to have the happy notion that this is something typical, which
frequently isn't the case.

What's worse, you're clearly of the opinion that this is something that
should be promoted to users, which is the "criminal" part of "criminally
stupid."

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

