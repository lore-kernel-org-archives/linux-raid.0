From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Thu, 28 Jun 2012 11:14:25 +0200
Message-ID: <4FEC2071.8010504@xunil.at>
References: <4FE9BFC1.5070607@xunil.at> <20120628163205.2c6a1122@notabene.brown> <4FEC1CE7.5010709@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FEC1CE7.5010709@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 28.06.2012 10:59, schrieb Stefan G. Weichinger:

>> If you have a machine with the same arch at the NAS, you could
>>
>> git clone git://neil.brown.name/mdadm -b mdadm-2.6.5 cd mdadm make
>> mdadm.static CWFLAGS=-Wall
>>
>> and then use the "mdadm.static" on the NAS.
> 
> Ok, thanks. I could boot some ubuntu on my Atom-netbook .. or what?
> Would it be enough to match the 64bit-environment, or would I have to
> use something with the same kernel ... ?

Update:

compiled mdadm.static on a 32bit machine and could re-add the two
partitions to the array! cool! thanks, Neil!

~500 mins to wait now.

Do I have to fear read-errors with RAID5 now?

I still don't fully understand if there are also 2 bits of
parity-informations available in a degraded RAID6 array on 2 disks only.

Thanks again so far, hoping the best now ;-)

Stefan
