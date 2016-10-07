From: Francisco Parada <advanceandconquer@gmail.com>
Subject: Re: RAID6 - CPU At 100% Usage After Reassembly
Date: Fri, 7 Oct 2016 07:23:49 -0400
Message-ID: <CAOW94uvxPH9dhpd=-t+eMfOc3YPLxasViz29idZmbQn-GkP5vg@mail.gmail.com>
References: <CADEsfxrKeSv5dRNfBoyybHaemPSqCcamTmSZ4P+Yey-rLd8hEg@mail.gmail.com>
 <CAOW94uv4zSGs+6be3zhcQaGZdiAgg-s4ZHZ=mszcURo6pqJyqA@mail.gmail.com>
 <CAOW94ute6CZafnAC6AVauqUGsEgVrnO3B27Gn3eVzdWFBJPCQw@mail.gmail.com>
 <CAOW94utnY1zCR7gUCx1K0p2YfDhi3tXTsE6J_mT6rNz1TuTZEQ@mail.gmail.com>
 <20160913174352.GA43576@kernel.org> <CAOW94us2=5F8BbLhQSN_mC0wghZA8Z6qFQHBP5Y1csJuQ4pfKg@mail.gmail.com>
 <CAOW94utVBcLz191ifzKkjn+nsSthPWDAQF8R-PabcS2uPareag@mail.gmail.com>
 <CAOW94usC2AFt4uGRZRidcXN1Gii0PqSqfGAjL6_2Y1m6GAcZsg@mail.gmail.com>
 <CAOW94uvFaiL9FO=k=gOsGzH0q1Qhw4X3n7ZFURj9_eTgGa656g@mail.gmail.com>
 <CAOW94uuALbxOpfb5Rgzp=Fgvy8zfKt94zCcgs7T=U-m8jWGq3g@mail.gmail.com> <20161006235530.GA109312@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161006235530.GA109312@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Sorry for the long delay.

No worries at all, Shaohua!!!! I really appreciate you getting back to me.

> Looks it showsthere are read errors in two disks and the raid6 thread is keeping loop to
handle the case, but doesn't success. The disks are sdd and sdg. I have no idea
how to fix this so far though, sorry.

OK, let me try running diagnostics on the disks again.  I ran
"badblocks" on them with the "-sv" options when I originally
encountered the issue, and only had found errors on one drive.  But
I'll run them again just in case, as well as a few other diagnostics.
I'll have to come up with something to try and detect the errors.  I'm
wondering if these read errors are caused by the controller, or the
drives themselves.  I can try swapping controllers.  Unless it's an
issue with the model drives that I'm using.  I've got WD 3TB Green
EZRX drives, which I recently found out via the RAID Wiki, that they
didn't have error correction (after I spent over a thousand dollars on
the drives in 3 years) ... Had I known better, I would have opted for
different models.

Thanks a million, Shaohua!



On Thu, Oct 6, 2016 at 7:55 PM, Shaohua Li <shli@kernel.org> wrote:
> On Wed, Oct 05, 2016 at 07:12:59AM -0400, Francisco Parada wrote:
>> Hi all,
>>
>> Just wanted to send one last ping on this.  I didn't hear back and
>> really don't know where else to turn to before abandoning hope.
>> Should I just start wiping the drives so I can start from scratch at
>> this point?
>>
>> I rebuilt the kernel with debug patch that Shaohua provided and I sent
>> the list the output of the trace.  Does any one have any other
>> suggestions?
>
> Sorry for the long delay. I got a chance to look at the log today. Looks it shows
> there are read errors in two disks and the raid6 thread is keeping loop to
> handle the case, but doesn't success. The disks are sdd and sdg. I have no idea
> how to fix this so far though, sorry.
>
> Thanks,
> Shaohua
