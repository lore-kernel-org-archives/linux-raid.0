From: Shaohua Li <shli@kernel.org>
Subject: Re: 4.10 + 765d704db: no improvemtn in write rates with md/raid5
 group_thread_cnt > 0
Date: Mon, 10 Apr 2017 13:10:57 -0700
Message-ID: <20170410201057.qxypmzaw4gtmkwvd@kernel.org>
References: <87zifvj61v.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87zifvj61v.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On Wed, Apr 05, 2017 at 03:13:48PM +0100, Nix wrote:
> So you'd expect write rates on a RAID-5 array to be higher than write rates on a
> single spinning-rust disk, right? Because, even with Shaohua's commit
> 765d704db1f583630d52 applied atop 4.10, I see little sign of it. Does this
> commit depend upon something else to stop death by seeking with
> group_thread_cnt > 0? It didn't look like it to me...
> 
> The results Shaohua showed in the original commit were very impressive, but for
> the life of me I can't figure out how to get anything like them.

That only works well with large iodepth. For single write, we are still far
from the BW in theory. I actually wrote in the commit log:

"We are pretty close to the maximum bandwidth in the large iodepth
iodepth case. The performance gap of small iodepth sequential write
between software raid and theory value is still very big though, because
we don't have an efficient pipeline."

Thanks,
Shaohua
 
> 
> With group_thread_cnt 0, I max out at a bit higher than the 240MiB/s one disk in
> this array can manage on its own, for obvious reasons: md_raid5 CPU saturation.
> (This is with a 512KiB chunksize, stripe_cache_size of 512: yes, I know that's
> small, it's just a random slice taken out of a much larger test series: the
> array is a smallish non-degraded unjournalled four-element md5 initialized with
> --assume-clean for benchmarking). Similar results are seen with ext4 and xfs.
> Trimmed-down iozone -a output, so only one serial writer, but still:
> 
>                                                        stride
>      kB  reclen    write  rewrite    read    reread      read
>      64       4     6752    15647    26489    30145     26678
>      64       8     6639    25236    45101    56289     43158
>      64      16     6014     9799    67364    89009     60900
>      64      32    35200    48781     7374   177207      7336
>      64      64    32420    70551   109395   229470     97868
> [...]
>   32768      64    28181    30576   265403   178438    299889
>   32768     128    41659    39989   319709   320689    330949
>   32768     256    45402    44555   320689   357564    451256
>   32768     512    42559    40556   177862   299744    466529
>   32768    1024    68005    52814   415747   391507    706177
>   32768    2048    91701   103918   520689   540128   1061339
>   32768    4096   177716   169486   487277   514111    683463
>   32768    8192   218923   233152   539853   616869    453021
>   32768   16384   199068   198872   569353   619913    535240
> [...]
>  262144      64    25148    32423   385802   378681     27762
>  262144     128    42510    41626   436994   380669     48004
>  262144     256    43415    44004   436209   418971     76697
>  262144     512    41408    40399   342862   401145    116781
>  262144    1024    68870    59341   465737   507454    265154
>  262144    2048   101994    91693   589277   582836    296474
>  262144    4096   176852   166200   581922   649215    421253
>  262144    8192   226696   221838   601174   633347    569766
>  262144   16384   307843   297985   644679   659060    569302
>  524288      64    25155    24527   392401   401908     21461
>  524288     128    41422    41525   433156   464331     35360
>  524288     256    42059    43742   443281   415799     70171
>  524288     512    41253    39360   414306   428993     75387
>  524288    1024    66081    61151   498880   517952    186959
>  524288    2048   101272    90418   610467   623258    274331
>  524288    4096   171489   173381   601689   576333    314290
>  524288    8192   220943   215226   641713   607459    444827
>  524288   16384   289055   296340   651010   671623    503633
> 
> Read rates are as high as I'd expect for a four-disk RAID-5 array, and the
> sequential write output rates, while higher than one one disk can manage, are
> thresholded here by the performance of the md I/O thread, as expected.
> 
> If I boost group_thread_cnt to, say, 2, I see:
> 
>      64       4     3677    14565    27936    36056     29629
>      64       8     6670    21608    53422    69187     32045
>      64      16     6682    26209    70329   103891     66662
>      64      32    28624    40048     7312   154556      7345
>      64      64    38327    43213    89127   260160     90540
> [...]
>   32768      64    14328    18580   265136   282946    308082
>   32768     128    26310    24803   265762   323414    354685
>   32768     256    29115    27073   238659   308974    345723
>   32768     512    21572    21345   293312   314086    345365
>   32768    1024    43978    38071   395715   345161    545821
>   32768    2048    82898    70840   293151   470398    922082
>   32768    4096   143350   124658   391980   659819    617984
>   32768    8192   164297   227661   570423   645141    515009
>   32768   16384   157701   171804   568484   451448    350715
> [...]
>  262144      64    17150    17693   391561   382751     28374
>  262144     128    25385    26498   423685   410359     47148
>  262144     256    29219    30244   392992   421748     80403
>  262144     512    24303    24686   399453   371882    122861
>  262144    1024    42296    42535   403020   508195    261339
>  262144    2048    75740    63125   606979   589329    296124
>  262144    4096   134646   137543   562749   590893    392938
>  262144    8192   237800   239847   631752   620766    475791
>  262144   16384   267889   304517   635674   612164    598521
>  524288      64    17691    17776   403333   374628     21673
>  524288     128    25575    25609   396568   439018     34526
>  524288     256    29984    29990   412587   437099     71650
>  524288     512    24971    25599   403074   431581     75471
>  524288    1024    42545    43657   505740   519112    200811
>  524288    2048    72519    75604   559987   589069    257654
>  524288    4096   135122   140745   622450   499336    331273
>  524288    8192   232848   231307   592729   604849    432296
>  524288   16384   280105   271252   647725   664868    472363
> 
> Larger writes are clearly still thresholded.
> 
> Boost the thread count more, here, to 8:
> 
>      64       4     7834    14388    30346    40300      6124
>      64       8    17236    21282     6984    37644      6842
>      64      16    21100    24720     7208   120277      7199
>      64      32    29411    45553     7374   162411      7357
>      64      64     3671    59588    78128   256923     82804
> [...]
>   32768      64    14261    17866   261303   289135    294245
>   32768     128    25832    27639   298172   324766    342822
>   32768     256    26477    27196   277318   339353    352967
>   32768     512    17848    19875   339424   272225    387746
>   32768    1024    36017    38945   482068   464194    110825
>   32768    2048    64240    67976   551762   505772     76629
>   32768    4096    71022   117680   578561   696507    752493
>   32768    8192   161080   207790   564343   556796    546488
>   32768   16384   172937   233103   521368   603562    418679
> [...]
>  262144      64    17170    17452   352337   351258     27824
>  262144     128    25318    25522   418977   424859     47112
>  262144     256    26405    27092   426170   419684     79047
>  262144     512    20185    20271   398733   411974    135554
>  262144    1024    39013    38238   497919   438150    180384
>  262144    2048    71054    70921   586634   535676    258955
>  262144    4096   113222   121554   616548   604177    293088
>  262144    8192   184086   187845   551395   586126    496147
>  262144   16384   286319   272419   645900   659103    589384
>  524288      64    16980    16756   385746   381476     21462
>  524288     128    24993    25482   428855   438250     34889
>  524288     256    26517    26134   448088   395352     70225
>  524288     512    19534    19484   418764   416630     76975
>  524288    1024    37645    38370   514030   511638    177818
>  524288    2048    68469    72200   602688   542627    251162
>  524288    4096   115467   121220   598738   629120    289589
>  524288    8192   185093   182044   621233   586919    437162
>  524288   16384   250990   266257   620428   660663    494770
> 
> Still thresholded. Yes, this is only one serial writer, but nonetheless this
> seems a bit od.
> 
> -- 
> NULL && (void)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
