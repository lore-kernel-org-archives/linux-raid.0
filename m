From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: softraid5 boot problem - partly my fault, solved
Date: Tue, 9 May 2006 21:02:41 +0200
Message-ID: <200605092102.42552.Dexter.Filmore@gmx.de>
References: <200605090006.32615.Dexter.Filmore@gmx.de> <20060509055048.GA22085@percy.comedia.it> <200605091235.58939.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200605091235.58939.Dexter.Filmore@gmx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mystery solved: had to probe another module. 
Wait, wait, I can defend myself :)

What led me to believe the controller was autoprobed during boot is that mdadm 
complained about *sdd*, but not about sd[abc], hence I assumed [abc] were all 
fine.
Plus, I didn't have to probe the module manually after boot was completed 
(appears that at that point some other module inserted it as a dependency).

So - is that how mdadm (or the kernel?) handle raid, is the last disk checked 
first by design?

Dex

-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
