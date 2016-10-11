From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RAID6 - CPU At 100% Usage After Reassembly
Date: Tue, 11 Oct 2016 11:53:53 +0800
Message-ID: <63380999-4291-97e9-41e4-363903e5c07b@fnarfbargle.com>
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
To: Francisco Parada <advanceandconquer@gmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/10/16 19:23, Francisco Parada wrote:

> issue with the model drives that I'm using.  I've got WD 3TB Green
> EZRX drives, which I recently found out via the RAID Wiki, that they
> didn't have error correction (after I spent over a thousand dollars on
> the drives in 3 years) ... Had I known better, I would have opted for
> different models.

That's not entirely true. EZRX drives have just as much "error 
correction" as any other drive. What they don't have is the ability to 
rapidly terminate their error correction (WD call it Time Limited Error 
Recovery or TLER). Nothing wrong with that provided your OS storage 
stack timeouts are set appropriately, as without that the drives will 
take longer to process the error than the OS will wait and things get 
ugly resulting in drives kicked from arrays.

Sure, they're not the best drives for the job, and buying new I wouldn't 
recommend them; but disable periodic head parking and spindown, set the 
timeouts appropriately and they'll do the job until they need replacing.

Regards,
Brad
