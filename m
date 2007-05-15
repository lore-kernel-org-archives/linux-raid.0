From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 11:44:34 +0200
Message-ID: <46498102.6030005@wpkg.org>
References: <4649760A.1060805@wpkg.org> <Pine.LNX.4.64.0705151019070.30502@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705151019070.30502@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson schrieb:
> On Tue, 15 May 2007, Tomasz Chmielewski wrote:
> 
>> I have a RAID-10 setup of four 400 GB HDDs. As the data grows by 
>> several GBs a day, I want to migrate it somehow to RAID-5 on separate 
>> disks in a separate machine.
>>
>> Which would be easy, if I didn't have to do it online, without 
>> stopping any services.
>>
>>
>> M1 - machine 1, RAID-10
>> M2 - machine 2, RAID-5
>>
>>
>> My first idea was to copy the data with rsync two or three times 
>> (because the files change, I would stop the services for the last run) 
>> - which turned out to be totally unrealistic - I started rsync process 
>> two days ago, and it still calculates files to be copied (over 100 
>> million files, with hardlinks etc.).
> 
> I have recent experience of copying up to 1TB parititions to offsite 
> backup servers via rsync (and a 10Mb line), and it can be done.
> 
> You do need a recent version of rsync and a lot of memory in both 
> servers. I'm really surprised it takes days to do this on your server - 
> although maybe the source server really is busy?

Yes, the server is really busy and reads/writes a lot - that's one. Two, 
it's being done over iSCSI in a pretty complicated scenario:


                     100 Mbit
M1 (RAID-10 storage) <--> very busy virtual machine in Xen
                            /
                           / 1 Gbit
                          /
      machine with rsync process <--> M2 (RAID-5 storage)
                                1 Gbit

So there is a slow point of just 100 Mbit to access the storage, which 
is normally fully filled anyway.

rsync, even 3.0, just doesn't fit here - it has to be done in sort of a 
"mirror" way.


-- 
Tomasz Chmielewski
htp://wpkg.org
