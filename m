From: Liwei <xieliwei@gmail.com>
Subject: Re: RAID6 grow unexpected results
Date: Fri, 23 Oct 2015 14:14:10 +0800
Message-ID: <CAPE0SYwiCn7L4iDKXS92pLz6JSLaXVdxggj-kE_bDDFM8w-ppg@mail.gmail.com>
References: <CAPE0SYz97qwHaQjgguZbQ3rdxKZjDdS9sg5F5dy10W3GP=U3+w@mail.gmail.com>
 <87io5yzg1a.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87io5yzg1a.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 23 Oct 2015 at 06:37 Neil Brown <nfbrown@novell.com> wrote:
>
> Liwei <xieliwei@gmail.com> writes:
>
> > Hi list,
> >     I tried growing a RAID6 array by executing the mdadm --add and
> > mdadm --grow --raid-devices commands. Usually that should run fine and
> > I can continue with pvresize.
>
> That is incorrect.  You cannot run "pvresize" until the reshape
> completes.


Ah, my bad. It's been a while since I did that. So if I had been
patient, all would have been well?

>
>
> >
> >     This time however, the actual usable raid array size did not
> > change even though reshape begins. In my confusion, I decided to
> > reboot. That didn't solve the problem (and apparently the reshape was
> > interrupted, but mdadm shows the grown array as clean?)
>
> Clean is expected.  It will be in an intermediate state, part has
> reshaped to extra devices, part is still the original.
>
> >
> >     I then executed mdadm --grow --size=max, which seemed to have
> > increased the array size, but apparently by too much. Now I'm getting
> > "attempt to access beyond end of device" errors for each of the
> > component drives. A new reshape operation has also begun, which I
> > expect would fail as the array size is now too big.
>
> "--size" isn't the same as "--array-size".
> "--size" is the size of the component devices to use.
>
> The "attempt to access beyond end of device" errors are unexpected but
> presumably related o the "--size=max".  Maybe the 'max' chosen was too
> large.  That suggests a bug somewhere.
> You probably want to reduce that size back to where it was.


I just realised I got the wrong command. I used --array-size=max
instead. A reboot seemed to have reverted the change.

>
>
> >
> >     What did I do wrong and how can I remedy this?
>
> Could we start with "mdadm --examine" status of all devices, "mdadm
> --detail" of the array, and all kernel messages that could possibly
> relate to the array since you first started this exercise?


Eventually it was a foul up on my part. Things seem to be back to
normal after a reboot, and the reshape is in progress. Apologies for
the confusion!

Liwei

>
>
> NeilBrown
>
> >
> > Liwei
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
