From: Thomas Grawert <thomasgrawert0282@gmail.com>
Subject: Re: help requested for mdadm grow error
Date: Tue, 26 May 2020 00:18:42 +0200
Message-ID: <b5e5c7af-9d1b-3eca-f3a1-f03f8d308015@gmail.com>
References: <7d95da49-33d8-cd4d-fa3f-0f3d3074cb30@gmail.com>
 <5ECC09D6.1010300@youngman.org.uk>
 <ff4ea9cd-ab35-0990-5946-4a72d4021658@gmail.com>
 <5ECC1488.3010804@youngman.org.uk>
 <4891e1e8-aaee-b36b-4131-ca7deb34defd@gmail.com>
 <alpine.DEB.2.20.2005252132080.7596@uplift.swm.pp.se>
 <103b80fa-029f-ecdc-d470-5cc591dc8dd0@gmail.com>
 <e1a4a609-2068-b084-59a6-214c88798966@youngman.org.uk>
 <e1ad56b2-df70-bc6a-9a81-333230d558c2@gmail.com>
 <358e9f6b-a989-0e4a-04c4-6efe2666159f@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <358e9f6b-a989-0e4a-04c4-6efe2666159f@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Okay, so we need to grep dmesg looking for a message like that above 
> about reshaping.
>
> So let's grep for "md/raid" and see what we get ...

root@nas:~# dmesg | grep md/raid
[  321.819562] md/raid:md0: not clean -- starting background reconstruction
[  321.819564] md/raid:md0: reshape_position too early for auto-recovery 
- aborting.


(again: thanks a lot for your help. I never expected that! :-) )
