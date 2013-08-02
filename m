From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RFC swap over raid1
Date: Fri, 02 Aug 2013 10:18:10 +0800
Message-ID: <51FB16E2.8070700@fnarfbargle.com>
References: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com> <51FB1274.3000302@fnarfbargle.com> <CAH3kUhFvybUQ+qptd4YJj8USwOtY+HMoanTqhsE3MLtzGKFskQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhFvybUQ+qptd4YJj8USwOtY+HMoanTqhsE3MLtzGKFskQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/08/13 10:02, Roberto Spadim wrote:
> hi brad, what kernel version you was using? anyone know if the new 3.9
> and 3.10 have a badblock feature at swap?
> anyone know who control the swap? or what source files should i look
> to understand swap better?

Back then it would have been 2.2 or possibly early 2.4.
Can't really help with the other questions. I still have large amounts 
of swap on all my machines for historical reasons, however it rarely 
gets touched and certainly not intentionally.

I find it much nicer to be able to deal with performance issues caused 
by a runaway processes forcing stuff into swap than it is to deal with 
"random" processes being shot by the OOM killer.


