From: David Greaves <david@dgreaves.com>
Subject: Re: mdadm create to existing raid5
Date: Fri, 13 Jul 2007 11:32:16 +0100
Message-ID: <469754B0.4020104@dgreaves.com>
References: <200707122318.l6CNIao08247@www.watkins-home.com> <469736E2.7040802@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <469736E2.7040802@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Jon Collette' <jon@etelos.com>
Cc: Guy Watkins <linux-raid@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> For a simple 4 device array I there are 24 permutations - doable by 
> hand, if you have 5 devices then it's 120, 6 is 720 - getting tricky ;)

Oh, wait, for 4 devices there are 24 permutations - and you need to do it 4 
times, substituting 'missing' for each device - so 96 trials.

4320 trials for a 6 device array.

Hmm. I've got a 7 device raid 6 - I think I'll go an make a note of how it's put 
together... <grin>


Have a look at this section and the linked script.
I can't test it until later

http://linux-raid.osdl.org/index.php/RAID_Recovery

http://linux-raid.osdl.org/index.php/Permute_array.pl


David


