From: Chris Murphy <lists@colorremedies.com>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 15:51:40 -0600
Message-ID: <470EDE51-0C70-4EF9-A7A7-7118BA73D802@colorremedies.com>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com> <A9ED9351-3430-43B8-AEA8-031B3DE29522@colorremedies.com> <6FAB7F92-66E2-4276-9774-B80DAC92E450@colorremedies.com> <20121029031851.42a5e1e9@natsu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121029031851.42a5e1e9@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 28, 2012, at 3:18 PM, Roman Mamedov <rm@romanrm.ru> wrote:

> Now you are moving into unfounded superstitions territory.

Umm, wholesale trusting data on drives is superstition.

> 
> You seem to imply that a Green drive would return just plain bad data in some
> failure condition (else why all the checksumming FSes?), and not an IO Error.

It certainly has a LOT longer to produce a result other than a read error. And we know ECC doesn't always correct for error correctly. So statistically there is a much larger window for bogus error to be returned that the drive thinks it has legitimately reconstructed. Absolutely.

> I don't think anything of this sort has been demonstrated so far, and while
> this could happen due to bad RAM/chipset/controller/bus/cache/etc, this would
> have nothing to do specifically with "Greenness" of a drive, nor any
> particular model would be inherently more prone to that.

It's a particular consumer drive that happens to not have a disable feature for ERC. The consumer Hitachi deskstars do, last I encountered them. So I don't mean to pick on just the green drives, so you're right that this isn't about the greenness of the drive. It is the particular SCT ERC behavior, and even more to that it's the ECC. Some implementations are better than others.

> 
>> But still, once a drive is asked to retrieve an LBA, so long as the drive eventually reports it back correctly, the file system won't correct that sector merely for a delay, even if it is up to 2 minutes or whatever it is. So, filesystem choice doesn't really solve the delay problem. You just have to obliterate the disk periodically with zeros or secure erase.
> 
> I do not think there is a state in modern HDDs that there would be a sector
> which consistently takes 30-120 seconds to read. Those are either unreadable at
> all, or readable after a delay -- and then already remapped by the HDD into the
> reserved zone, so the delay is not there the next time.

Could be. Seems unclear. And these behaviors change between firmware revisions so there are all kinds of variables changing constantly.


Chris Murphy

