From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Removing a failing drive from multiple arrays
Date: Thu, 26 Apr 2012 17:17:58 -0400
Message-ID: <4F99BB86.6000104@tmr.com>
References: <4F905F66.6070803@tmr.com> <20369.29756.761374.308057@quad.stoffel.home> <4F918F5C.2000607@anonymous.org.uk> <CAK2H+efwgznsS4==Rrtm6UE=uOb25-Q0Qm84i8yAJEJJ2JLdgg@mail.gmail.com> <4F9450D1.40305@anonymous.org.uk> <4F98B4FE.5010101@tmr.com> <20120426073607.GA11590@nsrc.org> <4F994695.9010509@tmr.com> <20120426132336.GA12692@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120426132336.GA12692@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Brian Candler wrote:
> On Thu, Apr 26, 2012 at 08:59:01AM -0400, Bill Davidsen wrote:
>>> Another option, although I've not done this for a long time, is PXE boot.
>>> You need a DHCP server giving out the correct parameters and a TFTP server
>>> for the kernel (and ramdisk?)
>>>
>> I think that's addressing one point of failure while adding more.
> Alternate point of view: you need reliable DNS anyway, and it's no harder to
> make reliable DHCP than reliable DNS (you just have two of them).
> Furthermore, this only needs to be available at the time a server boots up.
>
> I worked in one place where they made all the servers (which were VMs) pick
> up their IPs via DHCP.  This allowed them to dump the images across to the
> disaster recovery site, boot them up there, and bring them all up on new IPs
> without touching any configs.  It worked well.  They ran DHCP service on the
> Cisco L3 switches that the VM hosts were plugged into, on the basis that
> this was the most reliable kit that they had.
That is why my DNS/DHCP server is so vital :-(
I have been doing my IP assign that way for some years, and using the ability of 
KVM to set the MAC of the VM so I can take a fairly standard image and change 
the name of the machine and IP at boot time. I have had less luck getting IPv6 
working "right" and at the moment the IPv6 enabled servers get their IP from DNS 
look-up on their name, and their name from DHCP in IPv4. It's ugly but solid, 
I'm in not rush to find out why my IPv6 DHCP is unreliably.
> Like you say, it's a balancing act of cost, complexity, and reliability, and
> is also coloured by experience.  I've had not-so-good experiences with USB
> thumb drives.
>
I've had failures on the old ones due to write cycle fatigue. Once written it 
should be stable as a read-only device. That's my thinking, if SSD is reliable, 
then thumb drives should be slow but reliable, too. I'm saying that, feel free 
to provide your opinion or contradictory facts. I take little on faith myself.

-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



