From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: "md_raid5: page allocation failure" when resyncing on 3.2
Date: Tue, 10 Jan 2012 00:50:01 +0200
Message-ID: <4F0B6F19.7040903@gmail.com>
References: <4F0B2303.4080109@gmail.com> <20120110003107.432e4542@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120110003107.432e4542@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On =CE=94=CE=B5=CF=85=CF=84=CE=AD=CF=81=CE=B1, 9 =CE=99=CE=B1=CE=BD=CE=BF=
=CF=85=CE=AC=CF=81=CE=B9=CE=BF=CF=82 2012 8:31:07 =CE=BC=CE=BC, Roman M=
amedov wrote:
> On Mon, 09 Jan 2012 19:25:23 +0200
> Konstantinos Skarlatos<k.skarlatos@gmail.com>  wrote:
>
>> Hello, i got this kernel message when i was resyncing my md raid 5 a=
rray
>> on a linux 3.2 machine.
>
> This probably doesn't have much to do with md, it is a generic Linux =
kernel failure in the VM subsystem.
>
> If the search on bugzilla.kernel.org was up, I'd point you to bug num=
bers (there was quite a lot of reports), but it isn't, so just see:
> http://www.google.com/search?ie=3DUTF-8&q=3Dpage+allocation+failure
> https://bugzilla.redhat.com/buglist.cgi?quicksearch=3Dpage+allocation=
+failure
> e.g.: "they are happening during heavy network and disk activity when=
 the system has plenty of memory free"
> https://bugzilla.redhat.com/show_bug.cgi?id=3D551937
> and: "This is very common.  e1000 attempts to do large memory allocat=
ions from within interrupt context and the page allocator cannot satisf=
y the allocation and is not allowed to do the necessary work to make th=
e allocation attempt succeed.  It's the same with all net drivers"
> http://kerneltrap.org/mailarchive/linux-netdev/2009/4/13/5473414
>
Thanks for the links, i will try some of the solutions offered there.
> In your backtrace I see the system was also handling a network transf=
er with the r8169 driver; do you use jumbo frames there (MTU over 1500)=
?

Yes, i use jumbo frames. Will disabling them make things better or=20
worse?
Kind regards,
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
