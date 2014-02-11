From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Re[2]: Reassemble Raid 6
Date: Tue, 11 Feb 2014 00:13:56 +0000
Message-ID: <ema2a9c249-212d-4d96-a89b-b8e4a5d9f827@bigg>
References: <52F93C4B.8000909@turmel.org>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F93C4B.8000909@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Phil,

You are 100% correct. Thanks for your email. I had 2 separate ARRAY 
entries in my mdadm.config file. When I added the spare, I added the new 
information to the config file but did not remove the old entry. Total 
newbie mistake.

- I commented out all the previous entries in the mdadm.config file (it 
had a devices lists instead of the UUID information)

- I successfully assembled the array (mdadm --assemble /dev/md0  
/dev/sdb1 etc...)

- I  updated the config file using the information from mdadm -Esc 
partitions | grep UUID and deleted the old entries.

- I uncommented the fstab entry for the array and rebooted.


Everything is working perfectly now.


I remember reading somewhere that mdadm can run without the config file 
by using the RAID uuid and the information in the superblocks. Would 
this be more reliable?

Thanks Again,

- Justin

------ Original Message ------
From: "Phil Turmel" <philip@turmel.org>
To: "Justin Stephenson" <justin@evensteveninc.com>; 
linux-raid@vger.kernel.org
Sent: 10/02/2014 12:53:31 PM
Subject: Re: Reassemble Raid 6

>On 02/10/2014 11:48 AM, Justin Stephenson wrote:
>>  Hello,
>>
>>  I have reviewed the Linux Raid Wiki regarding rebuilding and it
>>  recommended writing a note to the list.
>>
>>  I am running an mdadm raid on CENTOS 6.5 with 6 disks in a Raid 6 off 
>>of
>>  my motherboard's SATA controller.
>>
>>  I added a 7th disk as a spare.
>>
>>  When I rebooted the raid after adding the spare, it would not mount 
>>and
>>  the OS would only boot into recovery mode. I changed my fsck file to
>>  exclude the raid and can now boot into the GUI.
>>
>>  I have tried to reassemble the array using --assemble and I get the 
>>the
>>  following message:
>>
>>  mdadm: we match both /dev/md/BigBlue:0 and /dev/md0 - cannot decide
>>  which to use.
>
>Please show the output of your mdadm.conf file, and the complete 
>command
>you used to assemble with. Add "-v" to it to show more information.
>
>{There's nothing wrong with your array, just conflicting info in your
>configuration file.}
>
>Phil

