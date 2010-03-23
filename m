From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: async/X threads and rebuild slowdown
Date: Tue, 23 Mar 2010 14:08:45 -0700
Message-ID: <e9c3a7c21003231408re62cd32q484fc26f326865b2@mail.gmail.com>
References: <hnnu9c$tsj$1@dough.gmane.org>
	 <318b7ac71003160624m16aad423lddca62c31021b104@mail.gmail.com>
	 <4B9F8C76.9010702@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9F8C76.9010702@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Tao Guo <glorioustao@gmail.com>, Jeremy Sanders <jeremy@jeremysanders.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 16, 2010 at 6:49 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 16/03/2010 13:24, Tao Guo wrote:
>>
>> I also meet this problem in several of my machines. If I change back
>> to kernel 2.6.18, it is
>> OK, but in 2.6.32 kernel, the performance is really poor.
>>
>> At last I found a solution, set CONFIG_MULTICORE_RAID456=n when
>> compiling raid456 module,
>> then everything goes normal. My machines do have multicore cpu, so it
>> is weird :<
>> Maybe there is something wrong with the CONFIG_MULTICORE_RAID456 enabled
>> code?
>
> I remember it being discussed on this list, so yes I think there is or was.
>

fyi,

https://bugzilla.redhat.com/show_bug.cgi?id=575897

--
Dan
