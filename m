From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Riad scrub generated errors, should I worry?
Date: Mon, 2 Mar 2015 11:32:38 -0700
Message-ID: <CAJCQCtR1th-V67c7dwZxNBFqKZ=96sAVLzyp4zscO-wPv9jA9g@mail.gmail.com>
References: <BLU436-SMTP203777F3704141DF5C096B898100@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP203777F3704141DF5C096B898100@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[253981.512570] sd 5:0:0:0: [sdf]
[253970.368375] Add. Sense: Unrecovered read error - auto reallocate failed
[253970.368380] end_request: I/O error, dev sdf, sector 5680577752

I'm confused. The above happens twice. So it seems clear the problem is
with /dev/sdf and sector 5680577752. Since it's an AF drive, technically
sectors 5680577752 - 5680577760 are affected, since those are the LBA's for
a single physical sector.

However, all of the "read error corrected" that follow have completely
different values, 5478837464 through 547883753.

And then 3 seconds later another read error at the same LBA:

[253977.980604] sd 5:0:0:0: [sdf]
253977.980605] Add. Sense: Unrecovered read error - auto reallocate failed
[253977.980612] end_request: I/O error, dev sdf, sector 5680579352

and 4 seconds later

[253981.512576] sd 5:0:0:0: [sdf]
[253981.512577] Add. Sense: Unrecovered read error - auto reallocate failed
[253981.512582] end_request: I/O error, dev sdf, sector 5680579352


And then "read error corrected" 5478839064 through 5478839136 which are
different than the first batch.

So there's a single LBA reported by libata as URE multiple times, each with
identical address. But then two corrected events, each with a different
range of sectors, neither of which match the URE address.

??


Chris Murphy
