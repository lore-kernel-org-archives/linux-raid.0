From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: async/X threads and rebuild slowdown
Date: Tue, 16 Mar 2010 13:49:42 +0000
Message-ID: <4B9F8C76.9010702@anonymous.org.uk>
References: <hnnu9c$tsj$1@dough.gmane.org> <318b7ac71003160624m16aad423lddca62c31021b104@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <318b7ac71003160624m16aad423lddca62c31021b104@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tao Guo <glorioustao@gmail.com>
Cc: Jeremy Sanders <jeremy@jeremysanders.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/03/2010 13:24, Tao Guo wrote:
> I also meet this problem in several of my machines. If I change back
> to kernel 2.6.18, it is
> OK, but in 2.6.32 kernel, the performance is really poor.
> 
> At last I found a solution, set CONFIG_MULTICORE_RAID456=n when
> compiling raid456 module,
> then everything goes normal. My machines do have multicore cpu, so it
> is weird :<
> Maybe there is something wrong with the CONFIG_MULTICORE_RAID456 enabled code?

I remember it being discussed on this list, so yes I think there is or was.

Cheers,

John.

