From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: problem killing raid 5
Date: Tue, 02 Oct 2007 00:35:32 +0400
Message-ID: <47015A14.9020400@msgid.tls.msk.ru>
References: <4700D454.7020607@gmail.com> <47013A6B.30302@gmail.com> <470140B5.3020203@msgid.tls.msk.ru> <47014368.4040204@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47014368.4040204@ucolick.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: Daniel Santos <daniel.dlds@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patrik Jonsson wrote:
> Michael Tokarev wrote:
[]
>> But in any case, md should not stall - be it during reconstruction
>> or not.  For this, I can't comment - to me it smells like a bug
>> somewhere (md layer? error handling in driver? something else?)
>> which should be found and fixed.  And for this, some more details
>> are needed I guess -- kernel version is a start.
> 
> Really? It's my understanding that if md finds an unreadable block
> during raid5 reconstruction, it has no option but to fail since the
> information can't be reconstructed. When this happened to me, I had to

Yes indeed, it should fail, but not stuck as Daniel reported.
Ie, it should either complete the work or fail, but not sleep
somewhere in between.

[]
> This is why it's important to run a weekly check so md can repair blocks
> *before* a drive fails.

*nod*.

/mjt
