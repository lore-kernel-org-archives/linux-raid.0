From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux raid wiki
Date: Mon, 26 Sep 2016 17:19:32 -0400
Message-ID: <33ee0032-11a7-3637-170a-a9da94c7bda9@turmel.org>
References: <57E469E0.4020005@youngman.org.uk>
 <57E67D32.30108@youngman.org.uk>
 <c6d53f0f-4434-9703-cfab-b148dd8dd68b@turmel.org>
 <57E95054.4020903@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E95054.4020903@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/26/2016 12:44 PM, Wols Lists wrote:
> The next section -
> 
> https://raid.wiki.kernel.org/index.php/Assemble_Run
> 
> addresses what to do if the array is messed up in some way. Would you
> mind taking a look at that now too :-)

Hmmm.  The last bit is less than ideal.  If all drives are faulty, but
runnable in the array with at least one drive of redundancy, the best
way to put good drives in service is one-by-one mdadm --replace.  That
lets the redundancy fix any errors, and doesn't load down the problem
drive any more than ddrescue would.  And it has the benefit of
increasing reliability as you go.

If you don't have any redundancy left, then ddrescue of all readable
drives is reasonable.

Phil

