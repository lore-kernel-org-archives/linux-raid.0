From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Linux raid wiki
Date: Mon, 26 Sep 2016 22:37:49 +0100
Message-ID: <57E9952D.6020703@youngman.org.uk>
References: <57E469E0.4020005@youngman.org.uk>
 <57E67D32.30108@youngman.org.uk>
 <c6d53f0f-4434-9703-cfab-b148dd8dd68b@turmel.org>
 <57E95054.4020903@youngman.org.uk>
 <33ee0032-11a7-3637-170a-a9da94c7bda9@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <33ee0032-11a7-3637-170a-a9da94c7bda9@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/09/16 22:19, Phil Turmel wrote:
> On 09/26/2016 12:44 PM, Wols Lists wrote:
>> The next section -
>>
>> https://raid.wiki.kernel.org/index.php/Assemble_Run
>>
>> addresses what to do if the array is messed up in some way. Would you
>> mind taking a look at that now too :-)
> 
> Hmmm.  The last bit is less than ideal.  If all drives are faulty, but
> runnable in the array with at least one drive of redundancy, the best
> way to put good drives in service is one-by-one mdadm --replace.  That
> lets the redundancy fix any errors, and doesn't load down the problem
> drive any more than ddrescue would.  And it has the benefit of
> increasing reliability as you go.
> 
> If you don't have any redundancy left, then ddrescue of all readable
> drives is reasonable.
> 
Which is the state this page is meant to cover. I'm assuming that if you
get this far, you have at an absolute minimum had to have done a
"--force --assemble" just to get a working array.

Each page has been intended to successively cover the state of the array
getting worse. The next page is "my metadata is trashed - mdadm says the
drive doesn't exist". I'm really not sure how to tackle that, but I know
there are several threads which cover damaged or trashed superblocks. I
think I'll just have to say "this is how you track down a GPT. This is
how you track down a superblock. This is how you interpret it. Get the
experts to help you put the array together again."

Cheers,
Wol

