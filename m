From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Sun, 17 Jul 2011 13:11:19 +0100
Message-ID: <4E22D167.2010905@anonymous.org.uk>
References: <201107162140.58883.raid1@fuckaround.org>    <4E226464.2030200@hardwarefreak.com> <ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <raid1@fuckaround.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/07/2011 09:12, Pol Hallen wrote:
> hello and thanks for the reply :-)
>
> dd if=/dev/zero of=test bs=4096 count=262144
> 262144+0 records in
> 262144+0 records out
> 1073741824 bytes (1.1 GB) copied, 31.3475 s, 34.3 MB/s

Pretty poor. CentOS 5, Intel ICH10, md RAID 6 over 5 7200rpm 1TB drives, 
then LVM, then ext3:
# dd if=/dev/zero of=test bs=4096 count=262144
262144+0 records in
262144+0 records out
1073741824 bytes (1.1 GB) copied, 2.5253 seconds, 425 MB/s

And there's a badblocks running on another drive also on the ICH10.

Having said that, I think mine's wrong too, I don't think my array can 
really manage that much throughput. We should both be using more 
realistic benchmarking tools like bonnie++:

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
beast.private.yu 7G 80890  91 67527  13 41608   4 74028  69 205104   9 
378.7   0
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++ 
+++++ +++
beast.private.yuiop.co.uk,7G,80890,91,67527,13,41608,4,74028,69,205104,9,378.7,0,16,+++++,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++

And I should think of a command line options so I don't get all those + 
signs. Never mind, the above shows 40-80MB/s for writes, 70-200MB/s for 
reads, which is not too bad even if it's not great.

Hang on. You aren't trying to benchmark your array just after creating 
it, while it's still doing its initial sync, are you?

Cheers,

John.

