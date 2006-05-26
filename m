From: Nix <nix@esperi.org.uk>
Subject: Re: problems with raid=noautodetect - solved
Date: Fri, 26 May 2006 01:10:15 +0100
Message-ID: <878xop1w9k.fsf@hades.wkstn.nix>
References: <4471B188.3060400@umit.at>
	<17522.15774.526526.244768@cse.unsw.edu.au> <447455E5.8050908@umit.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <447455E5.8050908@umit.at> (Florian Dazinger's message of "24 May 2006 13:48:01 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Florian Dazinger <florian.dazinger@umit.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24 May 2006, Florian Dazinger uttered the following:
> Neil Brown wrote:
>> Presumably you have a 'DEVICE' line in mdadm.conf too?  What is it.
>> My first guess is that it isn't listing /dev/sdd? somehow.
>> Otherwise, can you add a '-v' to the mdadm command that assembles the
>> array, and capture the output.  That might be helpful.
>> NeilBrown
>>
> stupid me! I had a DEVICE section, but somehow forgot about my /dev/sdd drive.

`DEVICE partitions' is generally preferable for that reason, unless
you have entries in /proc/partitions which you explicitly want to
exclude from scanning for RAID superblocks.

-- 
`On a scale of 1-10, X's "brokenness rating" is 1.1, but that's only
 because bringing Windows into the picture rescaled "brokenness" by
 a factor of 10.' --- Peter da Silva
