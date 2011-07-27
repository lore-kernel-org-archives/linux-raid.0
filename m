From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Wed, 27 Jul 2011 11:26:39 +0100
Message-ID: <4E2FE7DF.1020906@anonymous.org.uk>
References: <201107162140.58883.raid1@fuckaround.org>	<4E226464.2030200@hardwarefreak.com>	<ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org>	<4E22D167.2010905@anonymous.org.uk> <CAEUYfyMEj31Gfy9KeT4sHWyUXcB-+9ehoZoXvHSXq6yztCzVXg@mail.gmail.com> <4E2FE6C9.4070604@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E2FE6C9.4070604@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Simon Matthews <simon.d.matthews@gmail.com>, Pol Hallen <raid1@fuckaround.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/07/2011 11:22, Stan Hoeppner wrote:
> On 7/27/2011 12:42 AM, Simon Matthews wrote:
>> On Sun, Jul 17, 2011 at 5:11 AM, John Robinson
>> <john.robinson@anonymous.org.uk>  wrote:
>>
>>> Pretty poor. CentOS 5, Intel ICH10, md RAID 6 over 5 7200rpm 1TB drives,
>>> then LVM, then ext3:
>>> # dd if=/dev/zero of=test bs=4096 count=262144
>>> 262144+0 records in
>>> 262144+0 records out
>>> 1073741824 bytes (1.1 GB) copied, 2.5253 seconds, 425 MB/s
>>
>> What hard drive offers a sustained data rate of 425 MB/s or even half that?
>
> 425 MB/s / 3 spindles = 142 MB/s per spindle
>
> That's not poor, it's excellent.  Which drives are these?  WD Black,
> Seagate, Hitachi?

Gentlemen, we've been round this loop before about 10 days ago. Pol's 20 
MB/s was poor because he was testing on an array with unaligned 
partitions and a resync was running, my 425 MB/s was a bad test because 
it didn't use fdatasync or direct and I said dd was a bad test anyway, 
etc etc.

Cheers,

John.
