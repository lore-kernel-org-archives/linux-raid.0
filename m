From: Chris Murphy <lists@colorremedies.com>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 15:07:53 -0600
Message-ID: <6FAB7F92-66E2-4276-9774-B80DAC92E450@colorremedies.com>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com> <A9ED9351-3430-43B8-AEA8-031B3DE29522@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9ED9351-3430-43B8-AEA8-031B3DE29522@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 28, 2012, at 2:50 PM, Chris Murphy <lists@colorremedies.com> wrote:

> For any serious use I just wouldn't use the Greens, without very non-consumer like scrubs, extended smart tests, and cycling out drives so they could be ATA Enhance Secure Erase nuked say once a year or maybe more often. And a rigorous backup. With that kind of expertise and dedication should come a better budget for a better drive.

On 2nd thought, I'd consider the greens something like a "hostile witness" in legal jargon. Relegate them to only ZFS or btrfs (or ReFS maybe, unclear) for "raid" like pooling or redundancy. The drives themselves are inherently suspect so a suspicious grand inquisitor of a file system seems like an appropriate match, to constantly 2nd guess them.

But still, once a drive is asked to retrieve an LBA, so long as the drive eventually reports it back correctly, the file system won't correct that sector merely for a delay, even if it is up to 2 minutes or whatever it is. So, filesystem choice doesn't really solve the delay problem. You just have to obliterate the disk periodically with zeros or secure erase.


Chris Murphy


