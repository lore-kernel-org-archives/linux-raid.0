From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 16:42:09 -0700
Message-ID: <4C1A8E06-D76F-496D-9BC8-E1CF03209586@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com> <20130128225935.B8E2B20004B@gemini.denx.de> <ADB1B276-21F3-4006-A613-F979F931EDC3@colorremedies.com> <20130128232316.7B60A203AD5@gemini.denx.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130128232316.7B60A203AD5@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 28, 2013, at 4:23 PM, Wolfgang Denk <wd@denx.de> wrote:
> 
> Well, I did this - the repair worked without errors, but it left again
> a huge mismatch_cnt; raid6check on this array has not found any
> problems so far - even though I see mismatch_cnt = 362731480

Well, we don't know the nature of the bug. Also the method of testing can be confusing.

If this is a bug, and you used the buggy version combination to do a repair, maybe it's seeing good  parity as bad parity, and that's where the high mismatch count comes from. But then it replaces it with new parity, which could actually be bad, but either scrub or raid6check affected by the bug is seeing the bad parity as correct, hence no error. And my speculation is likely not helpful.

I think more eyeballs need to be on this to try and get a reproducer, and find out what's going on. So you should probably post something on the Fedora devel list. If it's a bug, better to squash it sooner than later. If it's a false alarm, oh well not much harm done.

Chris Murphy