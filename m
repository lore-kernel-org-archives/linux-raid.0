From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 17:45:56 -0400
Message-ID: <508DA794.9030106@meetinghouse.net>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com> <A9ED9351-3430-43B8-AEA8-031B3DE29522@colorremedies.com> <6FAB7F92-66E2-4276-9774-B80DAC92E450@colorremedies.com> <20121029031851.42a5e1e9@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121029031851.42a5e1e9@natsu>
Sender: linux-raid-owner@vger.kernel.org
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Roman Mamedov wrote:
> I do not think there is a state in modern HDDs that there would be a 
> sector which consistently takes 30-120 seconds to read. Those are 
> either unreadable at all, or readable after a delay -- and then 
> already remapped by the HDD into the reserved zone, so the delay is 
> not there the next time. 

Umm... yes.  This is a common near-failure mode with WD disks, as I 
learned the hard way when I discovered that I had a server that had been 
built with desktop drives rather than enterprise drives.  Took quite 
some time to figure out why my server was slowing WAY down. I still kind 
of wonder why md doesn't consider exceptionally long read times as a 
reason to drop a drive from a RAID array.

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra

