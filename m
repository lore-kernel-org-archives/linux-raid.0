From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: rebuild raid6 after two failures
Date: Tue, 31 Jan 2012 21:48:55 -0800
Message-ID: <7b0nv8x7u6.ln2@goaway.wombat.san-francisco.ca.us>
References: <8eekv8xpcn.ln2@goaway.wombat.san-francisco.ca.us>
 <kesmv8xc66.ln2@goaway.wombat.san-francisco.ca.us>
 <20120201163157.1605ec8c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-02-01, NeilBrown <neilb@suse.de> wrote:
>
> If a spare is being rebuild when another spare is added, it keeps with the
> first rebuild rather than restarting from the beginning.
>
> This means that you get some redundancy sooner, which is probably a good
> thing.

Great, thanks for the info.  I just wanted to check that the
behavior I saw earlier was expected.  (Yes, it's a good thing!)

--keith

-- 
kkeller@wombat.san-francisco.ca.us


