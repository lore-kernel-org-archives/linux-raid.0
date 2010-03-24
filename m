From: Randy Terbush <randy@terbush.org>
Subject: Re: (Re: Questions regarding startup of imsm container)
Date: Wed, 24 Mar 2010 15:35:42 -0600
Message-ID: <7db987b31003241435l5bf834cav716f904a119de642@mail.gmail.com>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
	<20100323080419.GA9374@maude.comedia.it> <7db987b31003230558l5993817fwb283c66bbf3633e9@mail.gmail.com>
	<7db987b31003230733n127ed0e2u35bbd1de3cb57733@mail.gmail.com>
	<e9c3a7c21003231541u705b60a1w9388a8225275dfa4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21003231541u705b60a1w9388a8225275dfa4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 23, 2010 at 4:41 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
>> And would sure like to have a write-intent bitmap active to avoid th=
is
>> resync issue which seems to be happening way too frequently.
>
> This could also be a problem with your distribution not taking care o=
f
> mdmon properly at shutdown. =A0The shutdown scripts need to keep mdmo=
n
> alive over the final "remounting rootfs readonly" event and wait for
> it to mark the array/metadata clean. =A0Otherwise there is a good cha=
nce
> that the array will be left dirty and require a resync at startup.
>
> Also note that recent versions of mdadm (3.1.2) and the kernel
> (2.6.33) can checkpoint imsm resyncs so at least it will not start
> over from the beginning when you reboot in the middle of a resync.

Does this functionality just work with the described version
combination, or is there something that needs to be done to activate
this behavior?

On a semi-related not, I believe I have worked out all of the startup
and shutdown issues and do have a imsm RAID configured that will now
survive a reboot without going int resync. However, I still am not
able to convince the array at startup to reconnect the external
write-intent bitmap. Is there some magic here that I am missing?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
