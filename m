From: John Robinson <john.robinson@yuiop.co.uk>
Subject: Re: Raid Problem - Unknown File System Type
Date: Thu, 10 Nov 2011 16:12:19 +0000
Message-ID: <4EBBF7E3.9030803@yuiop.co.uk>
References: <4EBAA68B.6090906@rogers.com> <20111109163933.GA26630@cthulhu.home.robinhill.me.uk> <4EBAB47C.5070002@rogers.com> <4EBACC88.8070403@turmel.org> <4EBADB1E.1070700@rogers.com> <4EBADD07.5030109@turmel.org> <4EBAE90F.2030104@rogers.com> <4EBAF46C.2030001@turmel.org> <4EBB46A5.8080305@rogers.com> <4EBB4B95.6040309@turmel.org> <4EBBEC80.9040709@rogers.com> <4EBBF26B.1090309@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBBF26B.1090309@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: William Colls <william.colls@rogers.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/11/2011 15:48, Phil Turmel wrote:
> On 11/10/2011 10:23 AM, William Colls wrote: [...]
>> the array was mounted as follows
>>
>> mount -t ext3 /dev/md0p1 /opt/share
>>
>> LVM was not installed on the old system, nor is it installed on the
>> new machine
[...]
> If none of this works, I'm out of ideas.  You'd probably want to ask
> for more help on the linux-ext4 mailing list.

The only thing that occurs to me is the possibility that both the md 
device was made from partitions, not whole drives, and the md device was 
itself partitioned. I wouldn't know quite how to go about checking though.

Cheers,

John.

-- 
John Robinson, yuiop IT services
0131 557 9577 / 07771 784 058
46/12 Broughton Road, Edinburgh EH7 4EE
