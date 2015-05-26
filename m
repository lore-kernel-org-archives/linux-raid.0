From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Tue, 26 May 2015 21:11:31 +0100
Message-ID: <5564D373.30705@youngman.org.uk>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com> <555294A0.6040703@websitemanagers.com.au> <CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com> <CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com> <alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se> <5561B237.4040709@youngman.org.uk> <5561BCA4.4060904@fnarfbargle.com> <5561C6E9.3060706@youngman.org.uk> <alpine.DEB.2.02.1505241604370.9487@uplift.swm.pp.se> <5561E5CE.7000304@youngman.org.uk> <alpine.DEB.2.02.1505241654580.9487@uplift.swm.pp.se> <CAOS+5GHz-4J_n7UAU1xVLWp3h7CRTuuSHdmP9rbL6=8=qx30CQ@mail.gmail.com> <5563AE50.4090806@youngman.org.uk> <CAOS+5GEBJ8dxF4s91dGmF7jx36LyNnu40UQZjLAmK2xVhqLAHw@mail.gmail.com> <alpine.DEB.2.02.1505261005260.9487@uplift.swm.pp.se> <CAOS+5GHW
 ktYuV2Q7NhsqybgFY5-QKRaGih0YcerD08_rKZp4Ng@mail.gmail.com> <alpine.DEB.2.02.1505261605450.9487@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1505261605450.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/05/15 15:08, Mikael Abrahamsson wrote:
> On Tue, 26 May 2015, Another Sillyname wrote:
> 
>> Very easy to understand......any way that requires entering the swaps
>> into /etc/fstab therefore means that if any drive and it's contained
>> swap fails the reboot can fail (plus the overhead of all those uuid
>> numbers in fstab).  My way means that as the swaps don't get loaded
>> unless the drive is alive the reboot has more resilience.
> 
> If you have RAID1 for swap, you only need a single component drive to
> work for the RAID1 to be able to start. It also means any drive can fail
> and your swap information still works.

And you're wasting a lot of disk space. What's important to you (that a
live swap disk shouldn't fail) is not important to me and doesn't seem
to be important to Another Sillyname.

My disk drives have 32Gb swap partitions. Overkill? Dunno. But I'd
rather linux raid 0's them for 64Gb swap than mdadm raid 1's them for
32Gb swap. I have a couple of 20Gb tmpfs partitions :-)

I don't know why Another Sillyname wants to chain his swap partitions,
but it's his choice. Maybe like me, his system gets rebooted a couple of
times a day, and failure to start is a far more real risk than failure
in use. He's running Fedora - that seems likely then ...

Cheers,
Wol
