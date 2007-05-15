From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 11:16:40 +0200
Message-ID: <46497A78.6030109@rabbit.us>
References: <4649760A.1060805@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4649760A.1060805@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Chmielewski wrote:
> I have a RAID-10 setup of four 400 GB HDDs. As the data grows by several
> GBs a day, I want to migrate it somehow to RAID-5 on separate disks in a
> separate machine.
> 
> Which would be easy, if I didn't have to do it online, without stopping
> any services.
> 
> 

Your /dev/md10 - what is directly on top of it? LVM? XFS? EXT3?
