From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: Re: siimage and two nics
Date: Sun, 28 Dec 2003 15:49:33 +0100
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <20031228154933.A5275@nettis.grimsta>
References: <20031226085450.A4045@nettis.grimsta> <34449.209.163.161.49.1072444479.squirrel@mail.clanhk.org> <20031226195705.B4045@nettis.grimsta> <3FEBAFA5.8020604@clanhk.org> <20031226232826.A7057@nettis.grimsta> <3FEBCA3C.5000803@clanhk.org> <20031227083050.A8631@nettis.grimsta> <3FECD15B.1010004@clanhk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FECD15B.1010004@clanhk.org>; from heretic@clanhk.org on Sat, Dec 27, 2003 at 12:24:59AM +0000
To: "J. Ryan Earl" <heretic@clanhk.org>
Cc: Daniel Brahneborg <daniel.com@wtnord.net>, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 27, 2003 at 12:24:59AM +0000, J. Ryan Earl wrote:
> I suggest the -mm tree, it includes all the patches for the siimage 
> driver, plus many more.  It has been stable in my testing.

I just tried that, but with the same data corruption problem
as with Linus tree: Writing large files on a raid5 disk causes
random data corruption.

I seem to get less DMA problems now though, which is very nice.

/Basic

