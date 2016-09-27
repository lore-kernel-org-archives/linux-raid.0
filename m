From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Tue, 27 Sep 2016 17:45:08 +0100
Message-ID: <57EAA214.8030603@youngman.org.uk>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
 <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
 <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
 <27577b8a-1b63-8f1a-9b68-b056622a5268@fnarfbargle.com>
 <41c176d2-0235-6ff0-996c-b32dc95d487d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41c176d2-0235-6ff0-996c-b32dc95d487d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/09/16 17:27, Benjammin2068 wrote:
> p.s. The Linux RAID Wiki doesn't cover mismatch_cnt at all.... would be kinda nice considering how critical (or not) this is... and what to do about it.

I'm thinking about all this. The second section is all about recovering
a failing/ed array, and is new. The first section is the original,
that's being updated. It just feels totally wrong to me now, as it's
becoming a jumbled mess of old and new.

What I'm probably going to do, is create a new first section about
setting up a raid system. That means that a section on monitoring will
actually make sense and fit between setting it up, and fixing problems.

(And all the old stuff will end up in the "software archaeology"
section, so people who are still running ancient systems can find it :-)

Cheers,
Wol
