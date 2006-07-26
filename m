From: David Greaves <david@dgreaves.com>
Subject: Re: host based mirror distance in a fc-based SAN environment
Date: Wed, 26 Jul 2006 11:56:15 +0100
Message-ID: <44C74A4F.4010504@dgreaves.com>
References: <45063.212.34.68.17.1153893489.squirrel@extern.x-cellent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45063.212.34.68.17.1153893489.squirrel@extern.x-cellent.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Majer <stefan@x-cellent.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stefan Majer wrote:
> Hi,
> 
> im curious if there are some numbers out up to which distance its possible
> to mirror (raid1) 2 FC-LUNs. We have 2 datacenters with a effective
> distance of 11km. The fabrics in one datacenter are connected to the
> fabrics in the other datacenter with 5 dark fibre both about 11km in
> distance.
> 
> I want to set up servers wich mirrors their LUNs across the SAN-boxen in
> both datacenters. On top of this mirrored LUN i put lvm2.
> 
> So the question is does anybody have some numbers up to which distance
> this method works ?

No. But have a look at man mdadm in later mdadm:

       -W, --write-mostly
             subsequent devices lists in a --build, --create,  or  --add
             command  will  be flagged as 'write-mostly'.  This is valid
             for RAID1 only and means that the 'md'  driver  will  avoid
             reading from these devices if at all possible.  This can be
             useful if mirroring over a slow link.

       --write-behind=
             Specify that write-behind mode should be enabled (valid for
             RAID1  only).  If an argument is specified, it will set the
             maximum number of outstanding writes allowed.  The  default
             value  is  256.  A write-intent bitmap is required in order
             to  use  write-behind  mode,  and  write-behind   is   only
             attempted on drives marked as write-mostly.

Which suggests that the WAN/LAN latency shouldn't impact you except on
failure.

HTH

David

-- 
