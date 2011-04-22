From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: debian software raid1
Date: Fri, 22 Apr 2011 15:19:57 -0400
Message-ID: <4DB1D4DD.7070901@cdf.toronto.edu>
References: <1303215166.2809.8.camel@valio> <BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com> <4DADB24F.2030300@cdf.toronto.edu> <20110420085148.12ac0002@notabene.brown> <4DAE29EA.4040306@gmail.com> <4DAEF2F1.8080204@cdf.toronto.edu> <20110421061545.GA15220@maude.comedia.it> <4DB04434.4080505@cdf.toronto.edu> <20110422055939.GA14247@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110422055939.GA14247@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 04/22/11 01:59, Luca Berra wrote:
> no, not the best example :D

I don't know why I'm even bothering to reply, given your all-knowing 
tone, but here it is anyway. Today, I was converting a system from 
single drive to mirrored with a 2nd 80GB drive. Here is proof that there 
are drives that both claim to be 80GB, but happen to be of different 
capacities:

sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
sd 2:0:0:0: [sdb] 156250000 512-byte logical blocks: (80.0 GB/74.5 GiB)

 > So, if i understood correctly, you use partitions on something which 
 > isnot a real HDD, hope you got the data alignment part correct.

You have misunderstood, and yes we are using partitions on real drives, 
and indeed yes, we've got the alignment part correct.

Cheers,
Iordan
