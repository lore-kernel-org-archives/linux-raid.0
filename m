From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mismatch_cnt questions
Date: Wed, 07 Mar 2007 23:00:31 -0800
Message-ID: <45EFB48F.3050101@zytor.com>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>	<17898.45673.573800.56474@notabene.brown>	<45EB3867.8050907@eyal.emu.id.au> <17899.18568.523543.478792@notabene.brown> <45EBCA83.40106@eyal.emu.id.au> <45EFAE65.9050608@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45EFAE65.9050608@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, Neil Brown <neilb@suse.de>, Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> Eyal Lebedinsky wrote:
>> Neil Brown wrote:
>> [trim Q re how resync fixes data]
>>> For raid1 we 'fix' and inconsistency by arbitrarily choosing one copy
>>> and writing it over all other copies.
>>> For raid5 we assume the data is correct and update the parity.
>>
>> Can raid6 identify the bad block (two parity blocks could allow this
>> if only one block has bad data in a stripe)? If so, does it?
>>
>> This will surely mean more value for raid6 than just the two-disk-failure
>> protection.
>>
> 
> No.  It's not mathematically possible.
> 

Okay, I've thought about it, and I got it wrong the first time 
(off-the-cuff misapplication of the pigeonhole principle.)

It apparently *is* possible (for notation and algebra rules, see my paper):

Let's assume we know exactly one of the data (Dn) drives is corrupt 
(ignoring the case of P or Q corruption for now.)  That means instead of 
Dn we have a corrupt value, Xn.  Note that which data drive that is 
corrupt (n) is not known.

We compute P' and Q' as the computed values over the corrupt set.

P+P' = Dn+Xn
Q+Q' = g^n Dn + g^n Xn		g = {02}

Q+Q' = g^n (Dn+Xn)

By assumption, Dn != Xn, so P+P' = Dn+Xn != {00}.
g^n is *never* {00}, so Q+Q' = g^n (Dn+Xn) != {00}.

(Q+Q')/(P+P') = [g^n (Dn+Xn)]/(Dn+Xn) = g^n

Since n is known to be in the range [0,255), we thus have:

n = log_g((Q+Q')/(P+P'))

... which is a well-defined relation.

For the case where either the P or the Q drives are corrupt (and the 
data drives are all good), this is easily detected by the fact that if P 
is the corrupt drive, Q+Q' = {00}; similarly, if Q is the corrupt drive, 
P+P' = {00}.  Obviously, if P+P' = Q+Q' = {00}, then as far as RAID-6 
can discover, there is no corruption in the drive set.

So, yes, RAID-6 *can* detect single drive corruption, and even tell you 
which drive it is, if you're willing to compute a full syndrome set (P', 
Q') on every read (as well on every write.)

Note: RAID-6 cannot detect 2-drive corruption, unless of course the 
corruption is in different byte positions.  If multiple corresponding 
byte positions are corrupt, then the algorithm above will generally 
point you to a completely innocent drive.

	-hpa
