From: GrantC <grant_nospam@dodo.com.au>
Subject: Re: Question regarding mdadm.conf
Date: Thu, 17 Feb 2005 22:11:45 +1100
Message-ID: <hpu811th02te01sre3heb04lhqb1ps7snh@4ax.com>
References: <42145487.3090701@gmx.com> <200502170844.j1H8ij924558@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: <200502170844.j1H8ij924558@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: "'Torsten E.'" <linux-user@gmx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 17 Feb 2005 03:44:40 -0500, you wrote:

>In the past, Neil has recommended using a device line like this:
>DEVICE partitions
>
. . .
>>   mdadm --detail --brief /dev/md1 | grep -v devices=

peetoo:~$  mdadm --detail --brief /dev/md1
ARRAY /dev/md1 level=raid0 num-devices=2 UUID=732ae5f8:e5d69879:30435be8:aafb7e94
   devices=/dev/hda6,/dev/hdc6

peetoo:~$  mdadm --detail --brief /dev/md1 | grep -v " devices="
ARRAY /dev/md1 level=raid0 num-devices=2 UUID=732ae5f8:e5d69879:30435be8:aafb7e94

Is that what was intended?

Cheers
Grant.



