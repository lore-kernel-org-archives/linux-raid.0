From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: RAID6 - CPU At 100% Usage After Reassembly
Date: Mon, 10 Oct 2016 20:52:33 +0100
Message-ID: <9a0fdb33-e722-6e1b-6fab-d2ccace8386d@youngman.org.uk>
References: <CADEsfxrKeSv5dRNfBoyybHaemPSqCcamTmSZ4P+Yey-rLd8hEg@mail.gmail.com>
 <CAOW94uv4zSGs+6be3zhcQaGZdiAgg-s4ZHZ=mszcURo6pqJyqA@mail.gmail.com>
 <CAOW94ute6CZafnAC6AVauqUGsEgVrnO3B27Gn3eVzdWFBJPCQw@mail.gmail.com>
 <CAOW94utnY1zCR7gUCx1K0p2YfDhi3tXTsE6J_mT6rNz1TuTZEQ@mail.gmail.com>
 <20160913174352.GA43576@kernel.org>
 <CAOW94us2=5F8BbLhQSN_mC0wghZA8Z6qFQHBP5Y1csJuQ4pfKg@mail.gmail.com>
 <CAOW94utVBcLz191ifzKkjn+nsSthPWDAQF8R-PabcS2uPareag@mail.gmail.com>
 <CAOW94usC2AFt4uGRZRidcXN1Gii0PqSqfGAjL6_2Y1m6GAcZsg@mail.gmail.com>
 <CAOW94uvFaiL9FO=k=gOsGzH0q1Qhw4X3n7ZFURj9_eTgGa656g@mail.gmail.com>
 <CAOW94uuALbxOpfb5Rgzp=Fgvy8zfKt94zCcgs7T=U-m8jWGq3g@mail.gmail.com>
 <20161006235530.GA109312@kernel.org>
 <CAOW94uvxPH9dhpd=-t+eMfOc3YPLxasViz29idZmbQn-GkP5vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOW94uvxPH9dhpd=-t+eMfOc3YPLxasViz29idZmbQn-GkP5vg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Parada <advanceandconquer@gmail.com>, Shaohua Li <shli@kernel.org>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 07/10/16 12:23, Francisco Parada wrote:
> I've got WD 3TB Green
> EZRX drives, which I recently found out via the RAID Wiki, that they
> didn't have error correction (after I spent over a thousand dollars on
> the drives in 3 years) ... Had I known better, I would have opted for
> different models.

There's more to greens than that. Apart from not having error recovery, 
they also apparently have a habit of going to sleep. Search the list for 
greens, but you need to do something else to stop them going to sleep, 
as that will also interfere with the raid.

I'll probably be adding that to the wiki at some point - I want to add a 
section on drives readily available, with that sort of information.

Cheers,
Wol
