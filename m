From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: SSD data reliable vs. unreliable [Was: Re: Data Recovery from
 	SSDs - Impact of trim?]
Date: Thu, 29 Jan 2009 01:49:55 +0000
Message-ID: <49810B43.20108@anonymous.org.uk>
References: <87f94c370901221553p4d3a749fl4717deabba5419ec@mail.gmail.com>	 <87f94c370901231526jb41ea66ta1d6a23d7631d63c@mail.gmail.com>	 <497A542C.1040900@redhat.com>	 <7fce22690901260659u30ffd634m3fb7f75102141ee9@mail.gmail.com>	 <497DE35C.6090308@redhat.com>	 <87f94c370901260934vef69a2cgada9ae3dfdb440ef@mail.gmail.com>	 <1232992065.3248.38.camel@localhost.localdomain>	 <18814.39074.194781.490676@notabene.brown>	 <497EE6A4.7030406@anonymous.org.uk> <4980BBE7.30808@tmr.com> <7fce22690901281556h67fb353dp879f88e6c2a76eaf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <7fce22690901281556h67fb353dp879f88e6c2a76eaf@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@norcrossgroup.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Ric Wheeler <rwheeler@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, Dongjun Shin <djshin90@gmail.com>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On 28/01/2009 23:56, Greg Freemyer wrote:
> Once discard calls get into linux file systems mdraid and/or device
> mapper could implement linux's own thin provisioning implementation.
> Even with traditional disks that don't support unmap.  I gather that
> is what the EMCs of the world will be doing in their platforms.
> 
> http://en.wikipedia.org/wiki/Thin_provisioning

Sounds more like a device mapper or LVM thing (than md/RAID) to me, but 
I'd definitely agree that this would be another great reason for block 
devices to implement map/unmap.

And I wonder if there's room for another dm/md device type which just 
implements these usage maps over traditional devices which don't support 
unmap (much as I was wondering a few weeks back about a soft DIF 
implementation over e.g. SATA devices). Darn it, I might just have to 
dig out my school books on C; it's a while since I offered a kernel patch.

Cheers,

John.

