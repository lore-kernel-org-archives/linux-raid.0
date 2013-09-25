From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Best configuration for bcache/md cache or other cache using ssd
Date: Tue, 24 Sep 2013 21:32:38 -0500
Message-ID: <52424B46.6000107@hardwarefreak.com>
References: <CAH3kUhHrK-TKJD1s_7SvtOz=YnpO82EvMGPv0X8rVAaDcuTO0Q@mail.gmail.com> <CAH3kUhHin5PfjDCNFjD8eypNML=0YrkQp14DrCADc2StcODdaw@mail.gmail.com> <CAH3kUhFf11O8a-y5W40ogrKu_XsjGfmi6R4YUmxbYw-McrEvyA@mail.gmail.com> <CACJz6QtDt-5mgtpHr092AyFOxoSoY+V7F8QbiUcDuD5JN7TsMA@mail.gmail.com> <CAH3kUhGNeXbmR+2zk+3KCDSaBfsjLuZQA89tG_C776emw0nSSQ@mail.gmail.com> <523A60DF.5040702@hardwarefreak.com> <CAH3kUhFaXEwR8ym8Vvf3yEODLf6mXOWnCQbk4qgLk7bnaepV3g@mail.gmail.com> <523AAC1F.6050006@hardwarefreak.com> <CAH3kUhG8cKsuG=-aJOuzJOV+5fe46E+QdCMczxghuL-MbWK95Q@mail.gmail.com> <523B1D1C.2070807@mpstor.com> <CAH3kUhF26nE7cro_Kkod6uZzLeEkhLtpDpbtF3ts2_F9hb4bYQ@mail.gmail.com> <523B26E9.30608@mpstor.com> <CAH3kUhE33h=7D6r7KO9VvQRN5qrZS+cadKUBQW8POFYvyGsS3w@mail.gmail.com> <523B3185.3020309@mpstor.com> <523B
 874D.4050904@hardwarefreak.com> <CAH3kUhH1FqvQX=Sx0s16AtYyOXUJky1p6kWAGQrbukFyUhJT1g@mail.gmail.com> <52414D81.4010104@hardwarefreak.com> <524181A6.6050303@NorthTech.US>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <524181A6.6050303@NorthTech.US>
Sender: linux-raid-owner@vger.kernel.org
To: "Bradley D. Thornton" <Bradley@NorthTech.US>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/24/2013 7:12 AM, Bradley D. Thornton wrote:

> On 09/24/2013 01:29 AM, Stan Hoeppner wrote:
>> On 9/24/2013 12:06 AM, Roberto Spadim wrote:
>>> Hi Stan,Benjamin, Drew and others guys!
>>
>> You desire to drink champagne on a beer budget I'm afraid.  You first
...
> Please don't BCC the list - it whacks people's mail filters. either To:
> or CC: is fine, but again, please don't BCC: the list okay?

Hi Bradley,

Thank you for scolding a mailop WRT the netiquette of BCC'ing a list. :)

"Reply to all" shouldn't cause this.  So what is the root cause?  Hmm...
let's see...  Here we go.  Take a look at the headers of Roberto's msg
to which I replied:

From:	Roberto Spadim <rspadim@gmail.com>
Cc:	Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
To:	unlisted-recipients:; (no To-header on input)


This mangled header caused TBird's reply-all to do the following:

To: Roberto Spadim <rspadim@gmail.com>
CC: unlisted-recipients:;, Linux-RAID <linux-raid@vger.kernel.org>


I've never used the feature, but AIUI, this "unlisted-recipients"
directive in TBird turns all subsequent CCs into BCCs.


So, my apologies for concentrating on the content of my reply, and not
paying closer attention to the headers before hitting send.  That said,
the root cause of this problem lay at the feet of Roberto, or his MUA,
for mangling the headers.  You may want to take this up with him, though
I'm sure he'll see this msg.

-- 
Stan

