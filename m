From: Chris Murphy <lists@colorremedies.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Sun, 8 Jun 2014 15:50:03 -0600
Message-ID: <E0F473C5-C7E6-4123-BD1E-BA109E9A691C@colorremedies.com>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com> <20140607075140.277c0880@natsu> <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com> <CAAMCDeddsKzi71KDBPik5i+wBp+On3gochDs_PqKoP9bN2szCQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDeddsKzi71KDBPik5i+wBp+On3gochDs_PqKoP9bN2szCQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jun 7, 2014, at 7:50 PM, Roger Heflin <rogerheflin@gmail.com> wrote:

> Check messages file and see if it has in the last few weeks reporting
> sectors bad.

No errors except the Current Pending sectors reported by smartd which dumps into the journal.
> 
> Or do a dd if=/dev/sda of=/dev/null read test until it hits something,
> then correct it, then continue on.

No errors.

> 
> Or do repeated long/selective tests to see if you can find them.

No (additional) errors.

> 
> Though, I had a seagate disk that I was able to get all of the pending
> to be fixed, I had to remove the disk from the raid as it still would
> randomly pause for 7 seconds while reading sectors that were not yet
> classified as pending.   I tried a number of things to try to get the
> disk to behave and/or replace those bad sectors, but finally gave up
> on that disk and just replaced it (out of warranty) as I could not
> ever get it to behave right.

I think this drive isn't behaving correctly, to say there are pending sectors yet passes the extended self-test.


Chris Murphy

