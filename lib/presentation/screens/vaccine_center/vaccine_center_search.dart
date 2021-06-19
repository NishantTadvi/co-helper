import 'package:co_helper/constants/strings.dart';
import 'package:co_helper/logic/cowin_centers/bloc/cowin_centers_bloc.dart';
import 'package:co_helper/presentation/widgets/filter_button.dart';
import 'package:co_helper/utility/extensions/map_apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi/mdi.dart';
import 'package:auto_route/auto_route.dart';

class VaccineCenterSearch extends StatefulWidget {
  @override
  _VaccineCenterSearchState createState() => _VaccineCenterSearchState();
}

class _VaccineCenterSearchState extends State<VaccineCenterSearch> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    final state = context.read<CowinCentersBloc>().state;
    _controller.text = state.searchValue ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(4),
            child: BlocListener<CowinCentersBloc, CowinCentersState>(
              listener: (context, state) {
                if (state.searchValue == null || state.searchValue == '') {
                  _controller.text = state.searchValue ?? '';
                }
              },
              listenWhen: (prevState, nextState) =>
                  prevState.searchValue != nextState.searchValue,
              child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (value) {
                  final state = context.read<CowinCentersBloc>().state;
                  if (value != state.searchValue)
                    context
                        .read<CowinCentersBloc>()
                        .add(CowinCentersSearchEvent(text: value));
                },
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: Strings.search,
                  labelText: Strings.search,
                  labelStyle: TextStyle(),
                  hintStyle: TextStyle(),
                  filled: true,
                  prefixIcon: IconButton(
                    icon: Icon(Mdi.magnify),
                    onPressed: () {},
                  ),
                  // suffixIcon: Icon(Mdi.filterVariant),
                  counterText: "",
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(12.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Material(
          elevation: 2,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              filterBottomSheet(context);
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(Mdi.filterVariant),
            ),
          ),
        )
      ],
    );
  }

  filterBottomSheet(BuildContext context) {
    return showModalBottomSheet<Widget>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bottomSheetContext) {
          return BlocProvider.value(
            value: BlocProvider.of<CowinCentersBloc>(context),
            child: Wrap(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 3,
                    width: 50,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: BlocBuilder<CowinCentersBloc, CowinCentersState>(
                      builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Filter",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Age Group",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            BlocBuilder<CowinCentersBloc, CowinCentersState>(
                              builder: (context, state) {
                                return FilterChip(
                                  label: Text("Age 18+"),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  onSelected: (value) {
                                    context.read<CowinCentersBloc>().add(
                                        CowinCentersFilterEvent(
                                            key: "min_age_limit", value: "18"));
                                  },
                                  selected: state.filters != null &&
                                      state.filters!
                                          .hasKeyValue("min_age_limit", "18"),
                                );
                              },
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            FilterChip(
                              label: Text("Age 45+"),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              onSelected: (value) {
                                context.read<CowinCentersBloc>().add(
                                    CowinCentersFilterEvent(
                                        key: "min_age_limit", value: "45"));
                              },
                              selected: state.filters != null &&
                                  state.filters!
                                      .hasKeyValue("min_age_limit", "45"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Vaccine",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            FilterChip(
                              label: Text("Covaxin"),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              onSelected: (value) {
                                context.read<CowinCentersBloc>().add(
                                    CowinCentersFilterEvent(
                                        key: "vaccine", value: "COVAXIN"));
                              },
                              selected: state.filters != null &&
                                  state.filters!
                                      .hasKeyValue("vaccine", "COVAXIN"),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            FilterChip(
                              label: Text("Covishield"),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              onSelected: (value) {
                                context.read<CowinCentersBloc>().add(
                                    CowinCentersFilterEvent(
                                        key: "vaccine", value: "COVISHIELD"));
                              },
                              selected: state.filters != null &&
                                  state.filters!
                                      .hasKeyValue("vaccine", "COVISHIELD"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Price",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            FilterChip(
                              label: Text("Free"),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              onSelected: (value) {
                                context.read<CowinCentersBloc>().add(
                                    CowinCentersFilterEvent(
                                        key: "fee_type", value: "Free"));
                              },
                              selected: state.filters != null &&
                                  state.filters!
                                      .hasKeyValue("fee_type", "Free"),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            FilterChip(
                              label: Text("Paid"),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              onSelected: (value) {
                                context.read<CowinCentersBloc>().add(
                                    CowinCentersFilterEvent(
                                        key: "fee_type", value: "Paid"));
                              },
                              selected: state.filters != null &&
                                  state.filters!
                                      .hasKeyValue("fee_type", "Paid"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        FilterButtonWidget(
                          onClick: () {
                            context
                                .read<CowinCentersBloc>()
                                .add(CowinCentersFilterSelectedEvent());
                            bottomSheetContext.popRoute();
                          },
                        )
                      ],
                    );
                  }),
                ),
              ],
            ),
          );
        });
  }
}
