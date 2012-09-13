From: John Robinson <john.robinson@yuiop.co.uk>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Thu, 13 Sep 2012 08:43:17 +0100
Message-ID: <50518E95.5050104@yuiop.co.uk>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com> <50504094.2040302@hesbynett.no> <CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com> <505059DD.8000108@hesbynett.no> <CACY-59dAbS=8ncRAeZrAYBAvo7G6FEyoGREHtC-ze4cwhiF9GQ@mail.gmail.com> <50518BA4.6090503@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50518BA4.6090503@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: GuoZhong Han <hanguozhong@meganovo.com>, stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/09/2012 08:30, David Brown wrote:
[...]
>   Using 2 x 8-disk raid6 connected by
> raid0 (or linear concat for XFS) will be faster and safer than a single
> large raid5/6 array, but unless you use the latest multithreaded raid
> kernel then it will still be very slow.

Not as far as I understand it, it won't. The multithreaded code is only 
really a benefit on SSDs which can manage tens of thousands of IOPS, 
while on spinning rust HDDs which can only manage hundreds of IOPS, the 
single-threaded code is fine.

Cheers,

John.

-- 
John Robinson, yuiop IT services
0131 557 9577 / 07771 784 058
46/12 Broughton Road, Edinburgh EH7 4EE
