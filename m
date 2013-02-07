From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID performance
Date: Thu, 7 Feb 2013 14:20:20 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302071418380.32644@uplift.swm.pp.se>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au>
 <5113A3D4.6000605@turmel.org> <5113A4E9.5020005@websitemanagers.com.au> <5113A628.6010304@turmel.org> <5113A741.7030504@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5113A741.7030504@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 8 Feb 2013, Adam Goryachev wrote:

> Though, like I said, would adding an extra SSD to the RAID5, and 
> reducing the size of all partitions by 20%, and then doing TRIM on that 
> newly freed space, would that improve performance because of the extra 
> free space the SSD can "work with" ?

Yes, that probably doubles the overprovisioning on the drive, which should 
be beneficial in a lot of aspects.

<http://en.wikipedia.org/wiki/Garbage_collection_(SSD)#Over-provisioning>

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
