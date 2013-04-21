From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Sat, 20 Apr 2013 21:48:12 -0500
Message-ID: <5173536C.2040108@hardwarefreak.com>
References: <5171CBF9.9020701@redhost.ro> <CAH3kUhEaZGON=fAyVMZOz5fH_DcfKv=hCa96UCeK4pN7k81c_Q@mail.gmail.com> <51725458.7020109@redhost.ro> <CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com> <51732422.1050109@redhost.ro>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51732422.1050109@redhost.ro>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/20/2013 6:26 PM, Andrei Banu wrote:

> They are connected through SATA2 ports (this does explain the read speed
> but not the pitiful write one) in AHCI.

These SSDs are capable of 500MB/s, and cost ~$1000 USD.  Spend ~$200 USD
on a decent HBA.  The 6G SAS/SATA LSI 9211-4i seems perfectly suited to
your RAID1 SSD application.  It is a 4 port enterprise JBOD HBA that
also supports ASIC level RAID 1, 1E, 10.

Also, the difference in throughput your show between RAID maintenance,
direct device access, and filesystem access suggests you have something
running between the block and filesystem layers, for instance LUKS.
Though LUKS alone shouldn't hammer your CPU and IO throughput so
dramatically.  However, if the SSDs do compression or encryption
automatically, and I believe the 840s do, the LUKS encrypted blocks may
cause the SSD firmware to take considerably more time to process the blocks.

-- 
Stan

